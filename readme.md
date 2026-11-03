# Práctica Integradora: Catálogo Móvil de Productos con ASP.NET Core y Flutter

Aplicación cliente-servidor para la consulta y registro de productos en tiempo real mediante intercambio de información en formato JSON a través del protocolo HTTP.

---

## Integrantes del Equipo (4 Integrantes)
* **Integrante 1:** David de Jesús González Ramírez
* **Integrante 2:** Edgar Fabian Perez Zepeda
* **Integrante 3:** Julio Cesar Inda Jimenez
* **Integrante 4:** Angel Gabriel Zuñiga Peralta

* **Asignatura:** Desarrollo para Móviles 2  
* **Institución:** UPEN Nayarit  
* **Docente:** Luis Gerardo Aguirre Cervantes  

---

## Tecnologías y Requisitos Previos

* **Backend:** .NET SDK 8.0 o superior (ASP.NET Core Web API).
* **Frontend:** Flutter SDK 3.x o superior & Dart.
* **Dependencias Flutter:** Paquete `http` (`^1.2.0` o superior).
* **Entornos de prueba compatibles:**
  * Navegador web (Google Chrome) para pruebas rápidas de interfaz.

---

## Instrucciones Paso a Paso para la Ejecución

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

## Contrato de la API y Endpoints

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
    "nombre": "Mouse",
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

## Serialización, Deserialización y Manejo de Errores

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

## Preguntas de Comprobación

### 1. ¿Cuál es la diferencia entre serializar y deserializar JSON?
* **Serializar:** Es el proceso de convertir una estructura de datos u objeto en memoria (como una clase en C# o una instancia en Dart) a una cadena de texto en formato JSON para poder transmitirla a través de la red o almacenarla . En el proyecto se realiza al enviar datos con `jsonEncode` en Flutter .
* **Deserializar:** Es el proceso inverso; toma una cadena de texto en formato JSON recibida del servidor y la transforma nuevamente en un objeto tipado en memoria (usando `jsonDecode` y el constructor `Producto.fromJson`) para que la aplicación pueda manipular sus propiedades con seguridad de tipos.

---

### 2. ¿Qué ocurriría si el servidor cambia el nombre de una propiedad del contrato?
El cliente en Flutter sufriría un fallo al deserializar los datos . Al buscar una clave que ya no existe en el mapa JSON (por ejemplo, si el servidor envía `"title"` en lugar de `"nombre"`), el valor recibido será `null` . Como en el modelo `Producto` los campos están declarados como obligatorios y no nulos (`required this.nombre`), la aplicación lanzará una excepción en tiempo de ejecución (como un error de casteo o fallo de aserción), impidiendo mostrar el catálogo en pantalla a menos que se actualice el modelo del cliente .

---

### 3. ¿Por qué el servidor debe generar el identificador del producto?
El servidor debe generar el identificador para garantizar la integridad, unicidad y consistencia de los datos . Si el cliente generara el `id`, dos usuarios podrían registrar productos al mismo tiempo con el mismo identificador (colisión de claves), o un cliente malintencionado podría sobreescribir registros existentes enviando identificadores arbitrarios+. El backend actúa como la única fuente de verdad.

---

### 4. ¿Qué diferencia hay entre los códigos HTTP 400 y 500?
* **400 Bad Request:** Indica un error atribuible al **cliente**. Ocurre cuando la petición enviada tiene una sintaxis incorrecta o no cumple con las reglas de negocio (por ejemplo, enviar un nombre vacío o un precio menor o igual a cero).
* **500 Internal Server Error:** Indica un fallo interno en el **servidor**. Ocurre cuando el backend experimenta una excepción no controlada, una falla técnica en su infraestructura o un error imprevisto en el código, independientemente de que los datos enviados por el cliente hayan sido válidos.

---

### 5. ¿Por qué conviene separar las peticiones HTTP de los widgets de interfaz?
Separar la lógica de red (en `ProductoService`) de los widgets de pantalla (en `CatalogoPage`) cumple con el principio de **separación de responsabilidades** y aporta los siguientes beneficios:
* **Mantenibilidad:** Si cambia la URL base, los encabezados o la librería de red, únicamente se modifica el archivo de servicio sin alterar el diseño visual.
* **Reutilización:** Múltiples pantallas o componentes pueden consultar o registrar productos utilizando el mismo método del servicio sin duplicar código.
* **Legibilidad y pruebas:** Los widgets se enfocan únicamente en renderizar la interfaz y reaccionar al estado, lo que facilita depurar errores visuales y realizar pruebas unitarias sobre las peticiones HTTP.


## Declaración de Uso de Inteligencia Artificial

* **Herramienta utilizada:** Gemini (Google).
* **Finalidad y alcance:**
  * Asistencia en el diseño arquitectónico del contrato de datos JSON entre ASP.NET Core y Dart.
  * Generación y revisión de los métodos de serialización (`jsonEncode`/`toJson`) y deserialización (`jsonDecode`/`fromJson`).
  * Asesoría técnica para resolver problemas de conectividad de red local (configuración de CORS, permisos en `AndroidManifest.xml` y direccionamiento hacia `10.0.2.2` en emuladores).
  * Redacción y estructuración de la documentación técnica y el archivo `README.md`.