public class ClashOfClansClient {
    public Clan getClan(String clanTag) {
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer {!$Credential.Password}');
        req.setEndpoint('callout:Clash_of_Clans/v1/clans/' + EncodingUtil.urlEncode(clanTag, 'UTF-8'));
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);
        return Clan.parse(res.getBody());
    }

    public ClanWarLog getClanWarLog(String clanTag) {
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer {!$Credential.Password}');
        req.setEndpoint('callout:Clash_of_Clans/v1/clans/' + EncodingUtil.urlEncode(clanTag, 'UTF-8') + '/warlog');
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(res.getBody());
        return ClanWarLog.parse(res.getBody());
    }

    public ClanWar getClanCurrentWar(String clanTag) {
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer {!$Credential.Password}');
        req.setEndpoint('callout:Clash_of_Clans/v1/clans/' + EncodingUtil.urlEncode(clanTag, 'UTF-8') + '/currentwar');
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);
        return ClanWar.parse(res.getBody());
    }
}