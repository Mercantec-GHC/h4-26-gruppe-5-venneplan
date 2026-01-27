using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using API.DBContext;
using API.Models;
using API.DTOS;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GroupsController : ControllerBase
    {
        private readonly AppDBContext _context;

        public GroupsController(AppDBContext context)
        {
            _context = context;
        }

        // GET: api/Groups
        [HttpGet("get")]
        public async Task<ActionResult<IEnumerable<GroupDTO>>> GetGroups()
        {
            var groups = await _context.Groups.ToListAsync();

            return Ok(groups);
        }

        // GET: api/Groups/5
        [HttpGet("get/{id}")]
        public async Task<ActionResult<SingularGroupDTO>> GetGroup([FromRoute] int id)
        {
            var group = await _context.Groups.FindAsync(id);
            if (group == null)
            {
                return NotFound();
            }

            return Ok(group);
        }

        // PUT: api/Groups/5
        [HttpPut("Edit/{id}")]
        public async Task<IActionResult> PutGroup([FromRoute] int id, [FromBody] SingularGroupDTO groupDto)
        {
            // Find existing entity
            var group = await _context.Groups.FindAsync(id);
            if (group == null)
            {
                return NotFound();
            }

            // Update allowed properties from DTO
            group.Name = groupDto.Name;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!GroupExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return Ok(group);
        }

        // POST: api/Groups
        [HttpPost("create")]
        public async Task<ActionResult<GroupDTO>> CreateGroup(GroupDTO dto)
        {
            var group = new Group
            {
                Name = dto.Name
            };
            _context.Groups.Add(group);
            await _context.SaveChangesAsync();

            return Ok(group);
        }

        [HttpPost("addGroupMember")]
        public async Task<IActionResult> AddGroupMember(GroupMemberDTO dto)
        {
            var groupMember = new GroupMember
            {
                GroupId = dto.GroupId,
                UserId = dto.UserId
            };
            _context.GroupMembers.Add(groupMember);
            await _context.SaveChangesAsync();
            return Ok(groupMember);
        }

        // DELETE: api/Groups/5
        [HttpDelete("delete/{id}")]
        public async Task<IActionResult> DeleteGroup([FromRoute] int id)
        {
            var group = await _context.Groups.FindAsync(id);
            if (group == null)
            {
                return NotFound();
            }

            _context.Groups.Remove(group);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool GroupExists(int id)
        {
            return _context.Groups.Any(e => e.Id == id);
        }
    }
}
