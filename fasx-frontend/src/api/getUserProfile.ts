export async function getUserProfile() {
  const token = localStorage.getItem("token")
  if (!token) {
    throw new Error("Нет токена в localStorage")
  }

  const res = await fetch(`http://87.249.50.183:5000/api/profile`, {
    method: "GET",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
  })

  if (!res.ok) {
    throw new Error("Не удалось получить данные профиля")
  }

  return res.json()
}