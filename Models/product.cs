namespace ApiProductos.Models;

public class Producto
{
    public int Id { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public decimal Precio { get; set; }
    public bool Disponible { get; set; }
}

public class CrearProductoDto
{
    public string? Nombre { get; set; }
    public decimal? Precio { get; set; }
}