global class LASessionID {

    @AuraEnabled
	public String key;
        @AuraEnabled
	public String id;
        @AuraEnabled
	public Integer clientPollTimeout;
        @AuraEnabled
	public String affinityToken;

	
	public static LASessionID parse(String json) {
		return (LASessionID) System.JSON.deserialize(json, LASessionID.class);
	}
}