namespace API.Models
{
    public class Group : Common
    {
        public required string Name { get; set; }

        public List<GroupMember>? GroupMembers { get; set; }
    }

}
