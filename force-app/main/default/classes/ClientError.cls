public class ClientError {
    public String reason;
    public String message;
    public String type;

    public static ClientError parse(String json) {
		return (ClientError) System.JSON.deserialize(json, ClientError.class);
    }
}