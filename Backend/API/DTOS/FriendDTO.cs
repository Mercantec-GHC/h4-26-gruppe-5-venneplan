namespace API.DTOS
{
    public class FriendDTO
    {
        public required int UserId { get; set; }
        public required int FriendId { get; set; }
        public required int FriendScore { get; set; }
        public required string FriendRequestStatus { get; set; }
    }
    public class AddFriendDTO
    {
        public required int UserId { get; set; }
        public required int FriendId { get; set; }
        public required int FriendScore { get; set; }
        public required string FriendRequestStatus { get; set; } = "pending";
    }

    public class AcceptFriendDTO
    {
        public required string FriendRequestStatus { get; set; } = "accepted";
    }
}
