package com.paasta.scwui.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Setter
@Getter
public class InstanceUser {

    @JsonSerialize
    @JsonProperty("no")
    private String no;

    @JsonSerialize
    @JsonProperty("instanceId")
    private String instanceId;

    @JsonSerialize
    @JsonProperty("userId")
    private String userId;

    @JsonSerialize
    @JsonProperty("repoRole")
    private String repoRole;

    @JsonSerialize
    @JsonProperty("createrYn")
    private String createrYn;

    @JsonSerialize
    @JsonProperty("createdDate")
    private Date createdDate;

    @JsonSerialize
    @JsonProperty("modifiedDate")
    private Date modifiedDate;

    public InstanceUser(){}

    public InstanceUser(String instanceId, String userId, String repoRole, String createrYn) {
        this.instanceId = instanceId;
        this.userId = userId;
        this.repoRole = repoRole;
        this.createrYn = createrYn;
        this.createdDate = new Date();
        this.modifiedDate = new Date();
    }
}
