const axios = require("axios");
const functions = require("firebase-functions");
const apiKey = functions.config().sendgrid.key;

function getDayWithSuffix(day) {
  if (day >= 11 && day <= 13) {
    return `${day}th`;
  }
  switch (day % 10) {
    case 1: return `${day}st`;
    case 2: return `${day}nd`;
    case 3: return `${day}rd`;
    default: return `${day}th`;
  }
}

function formatDate(timestamp) {
  const date = timestamp.toDate();
  const options = { year: "numeric", month: "long", day: "numeric" };
  const formattedDate = new Intl.DateTimeFormat("en-US", options).format(date);

  const dayWithSuffix = getDayWithSuffix(date.getDate());

  const hours = String(date.getUTCHours() + 9).padStart(2, '0');
  const minutes = String(date.getUTCMinutes()).padStart(2, '0');
  const ampm = date.getUTCHours() >= 12 ? 'PM' : 'AM';

  return `${formattedDate.replace(/\d+/, dayWithSuffix)} at ${hours}:${minutes} ${ampm}`;
}

async function sendEmail(recipientEmail, name, expiredTime, certificationName) {
  if (!apiKey) {
    throw new Error("SENDGRID_API_KEY environment variable is not set");
  }

  const apiUrl = "https://api.sendgrid.com/v3/mail/send";
  const formattedDate = formatDate(expiredTime);

  const data = {
    "personalizations": [
      {
        "to": [{"email": recipientEmail}],
        "dynamic_template_data": {
          "name": name,
          "expiredTime": formattedDate,
          "certification_name": certificationName,
        },
      },
    ],
    "from": {"email": "a.mason@pvp.co.jp"},
    "template_id": "d-9b3d5bf1242a4f479fcd781ed225e3c9",
  };

  try {
    const response = await axios.post(apiUrl, data, {
      headers: {
        "Authorization": `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
    });

    if (response.status === 202) {
      console.log("Email sent successfully");
    } else {
      console.log(`Failed to send email. Status code: ${response.status}`);
    }
  } catch (error) {
    console.error(`Error sending email: ${error}`);
  }
}

module.exports = {
  sendEmail,
};