const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

// Initialize Firebase Admin SDK
admin.initializeApp();

// Setup Nodemailer transport (using Gmail as an example)
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "aminenouioui15@gmail.com", // Replace with your Gmail address
    pass: "amine2010N", // Replace with your Gmail app-specific password
  },
});

// Cloud Function to send an email when a new user signs up
exports.sendWelcomeEmail = functions.auth.user().onCreate((user) => {
  const email = user.email; // The email of the new user
  const password = "user-password-not-available"; // Password is not available for security reasons

  const mailOptions = {
    from: "aminenouioui15@gmail.com",
    to: email,
    subject: "Welcome to Our App!",
    text: `Hello ${user.displayName || "User"},\n\n` +
          "Welcome to our app. Here are your details:\n\n" +
          `Email: ${email}\n` +
          `Password: ${password}\n\n` +
          "Please change your password after signing in for security reasons.",
  };

  return transporter.sendMail(mailOptions)
    .then(() => {
      console.log("Email sent successfully");
    })
    .catch((error) => {
      console.error("Error sending email:", error);
    });
});
