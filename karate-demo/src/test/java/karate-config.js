function fn() {
  return {
    baseUrl: "https://demoqa.com",
    userPayload: {
      userName: "user_" + Math.random().toString(36).substring(2,8),   //generates a random username
      password: "IniPasswordQa123!",
    },
  };
}
