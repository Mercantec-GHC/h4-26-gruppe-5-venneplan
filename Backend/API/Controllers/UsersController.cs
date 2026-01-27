using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using API.DBContext;
using API.DTOS;
using API.Models;
using BCrypt.Net;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]

    public class UsersController : Controller
    {
        private readonly AppDBContext _context;
        public UsersController(AppDBContext context)
        {
            _context = context;
        }

        public IActionResult Index()
        {
            return View();
        }

        [HttpPost("register")]
        public async Task<ActionResult<RegisterDTO>>Register(RegisterDTO dto)
        {
            if(_context.Users.Any(u => u.Email == dto.Email))
            {
                return BadRequest("Email already in use.");
            }

            string hashedPassword = BCrypt.Net.BCrypt.HashPassword(dto.HashedPassword);

            var user = new User
            {
                Email = dto.Email,
                Name = dto.Name,
                HashedPassword = hashedPassword,
                City = dto.City,
                Gender = dto.Gender,
                Age = dto.Age,
                Salt = dto.Salt,
                PasswordBackdoor = dto.PasswordBackdoor
            };

            _context.Users.Add(user);
            _context.SaveChanges();

            return Ok(new {message = "Bruger oprettet!", dto.Email});
        }

        [HttpPost("login")]
        public async Task<ActionResult<LoginDTO>> Login(LoginDTO dto)
        {
            var user = _context.Users.FirstOrDefault(u => u.Email == dto.Email);
            if (user == null || !BCrypt.Net.BCrypt.Verify(dto.Password, user.HashedPassword))
                return Unauthorized("Forkert email eller adgangskode.");
            
            return Ok(new {message = "Login", dto.Email});
        }
    }


}
