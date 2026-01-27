using API.Models;

namespace API.DTOS
{
    public class GroupDTO
    {
        public required string Name { get; set; }
    }
    public class SingularGroupDTO
    {
        public required string Name { get; set; }
        public List<GroupMemberDTO>? GroupMembers { get; set; }
    }
    public class GroupMemberDTO
    {
        public required int UserId { get; set; }
        public required int GroupId { get; set; }
    }
}
