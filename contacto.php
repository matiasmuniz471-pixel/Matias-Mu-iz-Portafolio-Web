<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $nombre = strip_tags(trim($_POST["nombre"]));
    $email = filter_var(trim($_POST["email"]), FILTER_SANITIZE_EMAIL);
    $asunto = strip_tags(trim($_POST["asunto"]));
    $mensaje = trim($_POST["mensaje"]);

    if (empty($nombre) || empty($mensaje) || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
        http_response_code(400);
        echo "Por favor completa el formulario correctamente.";
        exit;
    }

    $destinatario = "matiasmuniz471@gmail.com"; 
    $contenido = "Nombre: $nombre\n";
    $contenido .= "Email: $email\n\n";
    $contenido .= "Mensaje:\n$mensaje\n";

    $headers = "From: Matías Portfolio <no-reply@matiasmuniz.com>\r\n";
    $headers .= "Reply-To: $nombre <$email>\r\n";
    $headers .= "Content-Type: text/plain; charset=UTF-8\r\n";

    if (mail($destinatario, $asunto, $contenido, $headers)) {
        http_response_code(200);
        echo "¡Gracias! Tu mensaje ha sido enviado.";
    } else {
        http_response_code(500);
        echo "Oops! Algo salió mal y no pudimos enviar tu mensaje.";
    }
} else {
    http_response_code(403);
    echo "Hubo un problema con tu envío, por favor intenta de nuevo.";
}
?>
