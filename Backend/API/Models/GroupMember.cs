namespace API.Models
{
    public class GroupMember
    {
        public int Id { get; set; }
        public required string UserId { get; set; }
        public required int GroupId { get; set; }
        public User? User { get; set; }
        public Group? Group { get; set; }
    }
}
