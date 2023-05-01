/**
 * Utility methods to assist with anything to do with the Clash of Clans API
 */
public class ClashOfClansApiUtils {
    /**
     * API returns datetimes in the following format yyyyMMddThhmmss.SSSZ. 
     * Example: 20230501T004317.000Z
     */
    public static Datetime parseDttm(String dateTimeString) {
        List<String> dateTimeParts = dateTimeString.split('T');
		String datePart = dateTimeParts[0];
		Integer year = Integer.valueOf(datePart.left(4));
		Integer month = Integer.valueOf(datePart.substring(4, 6));
		Integer day = Integer.valueOf(datePart.right(2));

		String timePart = dateTimeParts[1];
		Integer hour = Integer.valueOf(timePart.left(2));
		Integer minute = Integer.valueOf(timePart.substring(2, 4));
		Integer second = Integer.valueOf(timePart.substring(4, 6));

        return Datetime.newInstance(year, month, day, hour, minute, second);
    }
}