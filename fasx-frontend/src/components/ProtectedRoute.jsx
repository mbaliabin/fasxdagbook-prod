import { Navigate } from "react-router-dom";

export const ProtectedRoute = ({ children }) => {
  const token = localStorage.getItem("token");

  if (!token) {
    // Если токена нет, мгновенно отправляем на логин
    return <Navigate to="/login" replace />;
  }

  return children;
};