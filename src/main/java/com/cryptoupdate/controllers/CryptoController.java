package com.cryptoupdate.controllers;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Collections;
import java.util.List;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.cryptoupdate.models.Coin;
import com.cryptoupdate.models.Crypto;
import com.cryptoupdate.models.User;
import com.cryptoupdate.services.UserService;
import com.cryptoupdate.validators.UserValidator;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken.Payload;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;

@Controller
public class CryptoController {
	private final UserService userService;
	private final UserValidator userValidator;

	public CryptoController(UserService userService, UserValidator userValidator) {
		this.userService = userService;
		this.userValidator = userValidator;
	}

	@RequestMapping("/")
	public String login(Model model) {
		model.addAttribute("user", new User());
		return "login.jsp";
	}

	@RequestMapping(value = "/registration", method = RequestMethod.POST)
	public String register(@Valid @ModelAttribute("user") User user, BindingResult result, HttpSession session,
			RedirectAttributes redirect) {
		userValidator.validate(user, result);
		if (userService.isEmailAlreadyInUse(user.getEmail())) {
			ObjectError emailError = new ObjectError("email", "That email is already being used");
			result.addError(emailError);
		}
		if (result.hasErrors()) {
			return "login.jsp";
		} else {
			User u = userService.registerUser(user);
			session.setAttribute("userId", u.getId());
			redirect.addFlashAttribute("success", "You have registered and are now on the home page!");
			return "redirect:/home";
		}
	}

	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public String login(@RequestParam("email") String email, @RequestParam("password") String password,
			RedirectAttributes redirect, HttpSession session) {
		if (userService.authenticateUser(email, password)) {
			User u = userService.findByEmail(email);
			session.setAttribute("userId", u.getId());
			redirect.addFlashAttribute("success", "You have logged in and are now on the home page!");
			return "redirect:/home";
		} else {
			redirect.addFlashAttribute("error", "Invalid Log In. Incorrect Email/Password.");
			return "redirect:/login";
		}
	}

	@RequestMapping("/home")
	public String home(Model model, HttpSession session, RedirectAttributes redirect) throws IOException, InterruptedException {
		Long id = (Long) session.getAttribute("userId");
		User user = userService.findUserById(id);
		model.addAttribute("user", user);
		System.out.println("In home route");
		String baseAPIURL = "https://api.coingecko.com/api/v3/coins/list?include_platform=false";
		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder()
				.GET()
				.header("accept", "application/json")
				.uri(URI.create(baseAPIURL))
				.build();
		HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
		String r = response.body();
		ObjectMapper mapper = new ObjectMapper();
		List<Crypto> cryptos = mapper.readValue(r, new TypeReference<List<Crypto>>() {});
		model.addAttribute("cryptocurrencies", cryptos);
		return "home.jsp";
	}
	
	@RequestMapping("/coin/{id}")
	public String getCoin(Model model, @PathVariable("id") String coinId) throws IOException, InterruptedException {
		String coin = coinId;
		String baseURL = "https://api.coingecko.com/api/v3/coins/";
		String addition = "?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=false";
		String coinAPIURL = baseURL + coinId + addition;
		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder()
				.GET()
				.header("accept", "application/json")
				.uri(URI.create(coinAPIURL))
				.build();
		HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
		String r = response.body();
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		Coin cryptoCoin = mapper.readValue(r, new TypeReference<Coin>() {});
		model.addAttribute("coin", cryptoCoin);
		System.out.println(cryptoCoin.toString());
		return "coin.jsp";
	}

	@RequestMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/";
	}

	@RequestMapping(value = "/tokensignin", method = RequestMethod.POST)
	public String tokenSignIn(@RequestParam("idtoken") String idTokenString, HttpSession session)
			throws Exception, IOException {

		NetHttpTransport transport = new NetHttpTransport();
		GsonFactory jsonFactory = new GsonFactory();

		GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(transport, jsonFactory)
				// Specify the CLIENT_ID of the app that accesses the backend:
				.setAudience(Collections
						.singletonList("445803876111-rjfijspv0l2rj6ck95tjfkj3n4ifpd2l.apps.googleusercontent.com"))
				// Or, if multiple clients access the backend:
				// .setAudience(Arrays.asList(CLIENT_ID_1, CLIENT_ID_2, CLIENT_ID_3))
				.build();

		// (Receive idTokenString by HTTPS POST)

		GoogleIdToken idToken = verifier.verify(idTokenString);
		System.out.println("In token verifier");
		if (idToken != null) {
			Payload payload = idToken.getPayload();

			// Print user identifier
			String userId = payload.getSubject();
			System.out.println("User ID: " + userId);

			// Get profile information from payload
			String email = payload.getEmail();
			boolean emailVerified = Boolean.valueOf(payload.getEmailVerified());
			String name = (String) payload.get("name");
			String pictureUrl = (String) payload.get("picture");
			String locale = (String) payload.get("locale");
			String familyName = (String) payload.get("family_name");
			String givenName = (String) payload.get("given_name");

			System.out.println(email);
			List<User> allUsers = userService.findAll();
			System.out.println(allUsers);
			for (int i = 0; i < allUsers.size(); i++) {
				System.out.println("in for loop within authentication");
				if (allUsers.get(i).getEmail().equals(email)) {
					session.setAttribute("userId", allUsers.get(i).getId());
					return "redirect:/home";
				}
			}

		} else {
			System.out.println("Invalid ID token.");
		}
		return "redirect:/home";
	}
}
