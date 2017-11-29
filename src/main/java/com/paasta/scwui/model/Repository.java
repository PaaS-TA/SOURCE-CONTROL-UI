package com.paasta.scwui.model;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.paasta.scwui.common.util.Common;
import com.paasta.scwui.common.util.DateUtil;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.hibernate.validator.constraints.NotEmpty;
import sonia.scm.repository.Permission;

import java.util.List;
import java.util.Map;

/**
 * Created by lena on 2017-06-16.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@Getter
@Setter
@ToString
public class Repository {

    @NotEmpty
    @JsonSerialize
    @JsonProperty("id")
    private String id;

    @NotEmpty
    @JsonSerialize
    @JsonProperty("name")
    private String name;

    @JsonSerialize
    @JsonProperty("description")
    private String description;

    @JsonSerialize
    @JsonProperty("type")
    private String type;

    @NotEmpty
    @JsonSerialize
    @JsonProperty("url")
    private String url;

    @JsonSerialize
    @JsonProperty("public")
    private boolean public_;

    @JsonSerialize
    @JsonProperty("archived")
    private boolean archived;

    @JsonSerialize
    @JsonProperty("contact")
    private String contact;

    @NotEmpty
    @JsonSerialize
    @JsonProperty("permissions")
    private List<Permission> permissions;

    @NotEmpty
    @JsonSerialize
    @JsonProperty("properties")
    private Map<String, String> properties;

    @NotEmpty
    @JsonSerialize
    @JsonProperty("creationDate")
    private long creationDate;

    @JsonSerialize
    @JsonProperty("lastModified")
    private long lastModified;

    public String  getDescription() {
        return Common.empty(this.description)  ? "" : this.description;
    }

    public String getCreationDate() {
        return this.creationDate > 0  ? DateUtil.convertLongToTime(this.creationDate) : "";
    }

    public String getLastModified() {
        return this.lastModified > 0 ? DateUtil.convertLongToTime(this.lastModified) : "";
    }

}