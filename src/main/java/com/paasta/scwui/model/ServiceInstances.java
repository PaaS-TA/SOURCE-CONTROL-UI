package com.paasta.scwui.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.validator.constraints.NotEmpty;

@Setter
@Getter
public class ServiceInstances {

    @NotEmpty
    @JsonSerialize
    @JsonProperty("instanceId")
    private String instanceId;

    @NotEmpty
    @JsonSerialize
    @JsonProperty("organizationGuid")
    private String organizationGuid;

    @NotEmpty
    @JsonSerialize
    @JsonProperty("organizationName")
    private String organizationName;

    @NotEmpty
    @JsonSerialize
    @JsonProperty("planId")
    private String planId;

    @NotEmpty
    @JsonSerialize
    @JsonProperty("seryiceId")
    private String seryiceId;

    @NotEmpty
    @JsonSerialize
    @JsonProperty("spaceGuid")
    private String spaceGuid;

    @NotEmpty
    @JsonSerialize
    @JsonProperty("createUserId")
    private String createUserId;

    @NotEmpty
    @JsonSerialize
    @JsonProperty("createdTime")
    private String createdTime;

}
