package com.paasta.scwui.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.validator.constraints.NotEmpty;

/**
 * Created by lena on 2017-06-16.
 */
@Setter
@Getter
public class Permission {

    @NotEmpty
    @JsonSerialize
    @JsonProperty("name")
    private String name;

    @NotEmpty
    @JsonSerialize
    @JsonProperty("type")
    private String type;

    @NotEmpty
    @JsonSerialize
    @JsonProperty("groupPermission")
    private boolean groupPermission;

   public Permission(String name, String type){
       this.name = name;
       this.type = type;
       groupPermission = false;
   }
    public Permission(){
   }
}
