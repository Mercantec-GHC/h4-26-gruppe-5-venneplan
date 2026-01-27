namespace API.Models
{
    public class GroupMember : Common
    {
        public required int UserId { get; set; }
        public required int GroupId { get; set; }
        public User? User { get; set; }
        public Group? Group { get; set; }
    }
}
