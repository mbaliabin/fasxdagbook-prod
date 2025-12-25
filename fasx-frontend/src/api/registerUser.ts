export async function registerUser(name: string, email: string, password: string) {
  // Заменяем http://87.249.50.183:5000/api на переменную из .env
  const res = await fetch(`${import.meta.env.VITE_API_URL}/auth/register`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ name, email, password }),
  });

  const data = await res.json();

  if (!res.ok) {
    throw new Error(data.error || "Ошибка регистрации");
  }

  return data;
}