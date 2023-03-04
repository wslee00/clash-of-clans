public class ClashOfClansClient {
    public Clan getClan(String clanTag) {
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer {!$Credential.Password}');
        req.setEndpoint('callout:Clash_of_Clans/v1/clans/' + EncodingUtil.urlEncode(clanTag, 'UTF-8'));
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return Clan.parse(res.getBody());
    }

    public void getClanWarLog(String clanTag) {
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer {!$Credential.Password}');
        req.setEndpoint('callout:Clash_of_Clans/v1/clans/' + EncodingUtil.urlEncode(clanTag, 'UTF-8') + '/warlog');
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
    }
}