public class ClashOfClansClient {
    public ClanWarLeagueGroup getCurrentWarLeagueGroup(String clanTag) {
        HttpResponse res = this.send(
            HttpMethod.GET, 
            'callout:Clash_of_Clans/v1/clans/' + EncodingUtil.urlEncode(clanTag, 'UTF-8') + '/currentwar/leaguegroup'
        );
        this.handleException(res);
        return ClanWarLeagueGroup.parse(res.getBody());
    }

    public ClanWar getClanWarLeagueWar(String warTag) {
        HttpResponse res = this.send(
            HttpMethod.GET, 
            'callout:Clash_of_Clans/v1/clanwarleagues/wars/' + EncodingUtil.urlEncode(warTag, 'UTF-8')
        );
        this.handleException(res);
        return ClanWar.parse(res.getBody());
    }

    public Clan getClan(String clanTag) {
        HttpResponse res = this.send(
            HttpMethod.GET, 
            'callout:Clash_of_Clans/v1/clans/' + EncodingUtil.urlEncode(clanTag, 'UTF-8')
        );
        this.handleException(res);
        return Clan.parse(res.getBody());
    }

    public ClanWarLog getClanWarLog(String clanTag) {
        HttpResponse res = this.send(
            HttpMethod.GET,
            'callout:Clash_of_Clans/v1/clans/' + EncodingUtil.urlEncode(clanTag, 'UTF-8') + '/warlog'
        );
        this.handleException(res);
        return ClanWarLog.parse(res.getBody());
    }

    public ClanWar getClanCurrentWar(String clanTag) {
        HttpResponse res = this.send(
            HttpMethod.GET, 
            'callout:Clash_of_Clans/v1/clans/' + EncodingUtil.urlEncode(clanTag, 'UTF-8') + '/currentwar'
        );
        return ClanWar.parse(res.getBody());
    }

    private HttpResponse send(HttpMethod httpMethod, String endpoint) {
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer {!$Credential.Password}');
        req.setEndpoint(endpoint);
        req.setMethod(httpMethod.name());
        Http http = new Http();
        return http.send(req);
    }

    private void handleException(HttpResponse res) {
        String responseBody = res.getBody();
        if (res.getStatusCode() != HttpStatusCode.OK) {
            ClientError clientError = ClientError.parse(responseBody);
            throw new ClashOfClansException(clientError.reason + ': ' + clientError.message);
        }
    }
}