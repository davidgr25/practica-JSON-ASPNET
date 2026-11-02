using Microsoft.AspNetCore.Mvc;
using ApiProductos.Models;

namespace ApiProductos.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ProductosController : ControllerBase
{
    // Almacenamiento en memoria estático para la práctica
    private static readonly List<Producto> _catalogo = new()
    {
        new Producto { Id = 1, Nombre = "Teclado", Precio = 650.00m, Disponible = true },
        new Producto { Id = 2, Nombre = "Audifonos", Precio = 499.00m, Disponible = true }
    };

    // GET /api/productos -> RF1
    [HttpGet]
    public ActionResult<IEnumerable<Producto>> Get()
    {
        return Ok(_catalogo);
    }

    // POST /api/productos -> RF2 & RF3
    [HttpPost]
    public ActionResult<Producto> Post([FromBody] CrearProductoDto dto)
    {
        if (dto == null || string.IsNullOrWhiteSpace(dto.Nombre) || dto.Precio == null || dto.Precio <= 0)
        {
            return BadRequest(new { mensaje = "El nombre es obligatorio y el precio debe ser mayor a 0." });
        }

        var nuevoId = _catalogo.Any() ? _catalogo.Max(p => p.Id) + 1 : 1;
        var nuevoProducto = new Producto
        {
            Id = nuevoId,
            Nombre = dto.Nombre.Trim(),
            Precio = dto.Precio.Value,
            Disponible = true
        };

        _catalogo.Add(nuevoProducto);

        return StatusCode(StatusCodes.Status201Created, nuevoProducto);
    }
}