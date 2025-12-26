export async function getUserProfile() {
  const token = localStorage.getItem("token")
  if (!token) {
    throw new Error("Нет токена в localStorage")
  }

  // Используем переменную окружения вместо жесткого IP
  const apiUrl = import.meta.env.VITE_API_URL || "https://fasx.pro";

  const res = await fetch(`${apiUrl}/api/profile`, {
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