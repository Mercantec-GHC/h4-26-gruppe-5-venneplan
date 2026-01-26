namespace API.Models
{
	public class Friend : Common
	{
		public required int userId { get; set; }
		public required int friendId { get; set; }
		public required int friendScore { get; set; }

		public User? User { get; set; }
	}
}