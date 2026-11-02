# Práctica Integradora: Catálogo Móvil de Productos con ASP.NET Core y Flutter

Aplicación cliente-servidor para la consulta y registro de productos en tiempo real mediante intercambio de información en formato JSON a través del protocolo HTTP.

---

## 👥 Integrantes del Equipo (4 Integrantes)
* **Integrante 1:** David de Jesús González Ramírez
* **Integrante 2:** [Nombre y Apellidos]
* **Integrante 3:** [Nombre y Apellidos]
* **Integrante 4:** [Nombre y Apellidos]

* **Asignatura:** Desarrollo para Móviles 2  
* **Institución:** UPEN Nayarit  
* **Docente:** I.S.C. Luis Gerardo Aguirre Cervantes  

---

## 🛠️ Tecnologías y Requisitos Previos

* **Backend:** .NET SDK 8.0 o superior (ASP.NET Core Web API).
* **Frontend:** Flutter SDK 3.x o superior & Dart.
* **Dependencias Flutter:** Paquete `http` (`^1.2.0` o superior).
* **Entornos de prueba compatibles:**
  * Emulador oficial de Android (Android Studio).
  * Dispositivo físico Android conectado a la misma red Wi-Fi o mediante depuración USB.
  * Navegador web (Google Chrome) para pruebas rápidas de interfaz.

---

## 📁 Estructura del Repositorio

```text
catalogo-productos/
├── ApiProductos/                  # Servidor Backend (ASP.NET Core)
│   ├── Controllers/
│   │   └── ProductosController.cs  # Endpoints GET y POST con validaciones
│   ├── Models/
│   │   └── Producto.cs             # Modelos de entidad y DTO de entrada
│   ├── Program.cs                  # Configuración de servicios y CORS
│   └── ApiProductos.csproj
│
├── catalogo_movil/                # Cliente Móvil (Flutter)
│   ├── lib/
│   │   ├── models/
│   │   │   └── producto.dart       # Modelo Dart con fromJson y toJson
│   │   ├── services/
│   │   │   └── producto_service.dart # Consumo HTTP y manejo de errores
│   │   └── main.dart               # Interfaz gráfica (Catálogo y Formulario)
│   ├── pubspec.yaml
│   └── android/app/src/main/AndroidManifest.xml
│
├── capturas/                      # Evidencias visuales de la práctica
│   ├── 01_get_catalogo.png
│   ├── 02_formulario_registro.png
│   ├── 03_post_exitoso.png
│   └── 04_post_invalido_400.png
│
└── README.md                      # Documentación integral del proyecto
```

---

## 🚀 Instrucciones Paso a Paso para la Ejecución

### 1. Puesta en Marcha del Servidor (ASP.NET Core)

1. Abre una terminal y dirígete al directorio de la API:
   ```bash
   cd ApiProductos
   ```
2. Ejecuta el servidor permitiendo que escuche peticiones desde cualquier dirección de red local:
   ```bash
   dotnet run --urls "http://0.0.0.0:5000"
   ```
3. Verifica que la API esté activa abriendo la documentación interactiva de Swagger en tu navegador:
   `http://localhost:5000/swagger`

---

### 2. Configuración de Red en el Cliente (Flutter)

Antes de lanzar la app móvil, abre el archivo `catalogo_movil/lib/services/producto_service.dart` y ajusta la variable `baseUrl` según el dispositivo donde vas a correr la aplicación:

```dart
// En catalogo_movil/lib/services/producto_service.dart:
static const String baseUrl = 'http://DIRECCION_IP:5000/api/productos';
```

* **Si usas el Emulador Oficial de Android:**
  Utiliza la IP de puente loopback del emulador:
  ```dart
  static const String baseUrl = 'http://10.0.2.2:5000/api/productos';
  ```
* **Si usas un Dispositivo Físico (Celular por Wi-Fi):**
  Averigua la dirección IPv4 de tu computadora con `ipconfig` en Windows (ejemplo: `192.168.1.75`) y configúrala así:
  ```dart
  static const String baseUrl = 'http://192.168.1.75:5000/api/productos';
  ```
  *(Nota: La PC y el celular deben estar conectados exactamente a la misma red Wi-Fi).*
* **Si ejecutas la app en Chrome (Web):**
  ```dart
  static const String baseUrl = 'http://localhost:5000/api/productos';
  ```

---

### 3. Puesta en Marcha del Cliente Móvil (Flutter)

1. Abre una **segunda terminal** (mantén la terminal de la API en ejecución).
2. Entra a la carpeta de Flutter:
   ```bash
   cd catalogo_movil
   ```
3. Descarga e instala los paquetes necesarios:
   ```bash
   flutter pub get
   ```
4. Inicia la aplicación en tu dispositivo o emulador:
   ```bash
   flutter run
   ```

---

## 📋 Contrato de la API y Endpoints

### 1. `GET /api/productos` (RF1)
* **Propósito:** Devuelve la lista completa de productos disponibles en el catálogo.
* **Cuerpo enviado (Request):** *Vacío*
* **Código de respuesta exitosa:** `200 OK`
* **Ejemplo de respuesta (JSON):**
  ```json
  [
    {
      "id": 1,
      "nombre": "Teclado",
      "precio": 650.00,
      "disponible": true
    },
    {
      "id": 2,
      "nombre": "Audifonos",
      "precio": 499.00,
      "disponible": true
    }
  ]
  ```

### 2. `POST /api/productos` (RF2 y RF3)
* **Propósito:** Registra un nuevo producto en el catálogo en memoria.
* **Encabezados requeridos:** `Content-Type: application/json`
* **Cuerpo enviado (Request):**
  ```json
  {
    "nombre": "Mouse Inalámbrico",
    "precio": 299.50
  }
  ```
* **Respuestas esperadas:**
  * **Éxito (`201 Created`):** El servidor asigna el `id` autoincrementable y establece `disponible: true`. Devuelve el objeto completo registrado.
  * **Error de Validación (`400 Bad Request`):** Si el `nombre` está vacío o el `precio` es menor o igual a 0. Devuelve:
    ```json
    {
      "mensaje": "El nombre es obligatorio y el precio debe ser mayor a 0."
    }
    ```

---

## 📖 Explicación Técnica: Serialización, Deserialización y Manejo de Errores

### 1. Flujo de Serialización y Deserialización
El intercambio de información requiere transformar estructuras de datos entre representaciones en memoria y cadenas de texto plano en formato JSON:

* **En el Servidor (ASP.NET Core):**
  * **Deserialización:** Al recibir la solicitud HTTP `POST`, el motor de enlace de modelos (*Model Binding*) analiza el flujo entrante en JSON y lo convierte a una instancia de la clase `CrearProductoDto` en C#.
  * **Serialización:** Cuando el controlador retorna `Ok(_catalogo)` o `StatusCode(201, nuevoProducto)`, el serializador integrado `System.Text.Json` transforma los objetos de C# en una cadena JSON formateada, adjuntando la cabecera `Content-Type: application/json`.
* **En el Cliente (Flutter / Dart):**
  * **Serialización:** En `ProductoService.registrarProducto()`, los valores capturados del formulario se agrupan en un mapa nativo de Dart y se procesan con `jsonEncode(...)`, produciendo una cadena JSON enviada en el cuerpo de la petición HTTP.
  * **Deserialización:** En `ProductoService.obtenerProductos()`, la respuesta cruda en texto plano (`response.body`) se transforma primero en colecciones dinámicas mediante `jsonDecode(...)` y posteriormente se mapea elemento por elemento mediante el constructor de fábrica `Producto.fromJson()`, asegurando un tipado estricto (`int`, `String`, `double`, `bool`) listo para ser consumido por la interfaz de usuario.

### 2. Estrategia de Manejo de Errores
* **Lado Servidor:** Se implementó validación defensiva en el controlador. Ante datos inconsistentes (cadenas vacías o precios $\le 0$), el servidor aborta la creación y responde con código `400 Bad Request` y un mensaje explícito.
* **Lado Cliente:** 
  * `ProductoService` evalúa el `response.statusCode`. Si detecta un código distinto de `200` o `201`, decodifica la respuesta y propaga una excepción con el mensaje retornado por el backend.
  * La interfaz gráfica en `main.dart` captura las excepciones mediante bloques `try-catch`, desplegando notificaciones flotantes (`SnackBar`) comprensibles para el usuario y mostrando vistas de error con opciones de reintento en caso de fallos de conexión o caídas del servidor.

---

## 📸 Evidencias de Funcionamiento

Las capturas de pantalla que respaldan la rúbrica se ubican en la carpeta `/capturas`:

1. **`01_get_catalogo.png`:** Consulta GET exitosa con código `200 OK` y catálogo de productos renderizado en la interfaz móvil.
2. **`02_formulario_registro.png`:** Formulario interactivo abierto para capturar nombre y precio de un nuevo elemento.
3. **`03_post_exitoso.png`:** Solicitud POST completada con código `201 Created` y producto añadido inmediatamente a la lista con su respectivo ID asignado.
4. **`04_post_invalido_400.png`:** Solicitud con datos inválidos (precio menor o igual a cero o nombre vacío) mostrando la respuesta `400 Bad Request` y la alerta visual en Flutter.

---

## 🤖 Declaración de Uso de Inteligencia Artificial

* **Herramienta utilizada:** Gemini (Google).
* **Finalidad y alcance:**
  * Asistencia en el diseño arquitectónico del contrato de datos JSON entre ASP.NET Core y Dart.
  * Generación y revisión de los métodos de serialización (`jsonEncode`/`toJson`) y deserialización (`jsonDecode`/`fromJson`).
  * Asesoría técnica para resolver problemas de conectividad de red local (configuración de CORS, permisos en `AndroidManifest.xml` y direccionamiento hacia `10.0.2.2` en emuladores).
  * Redacción y estructuración de la documentación técnica y el archivo `README.md`.