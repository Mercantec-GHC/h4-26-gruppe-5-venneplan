namespace API.Models
{
	public class Friend : Common
	{
		public required int UserId { get; set; }
        public required int FriendId { get; set; }
		public required int FriendScore { get; set; }
		public string FriendRequestStatus { get; set; } = "pending";

        public User? User { get; set; }
	}
}