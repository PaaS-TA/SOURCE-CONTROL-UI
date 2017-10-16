package com.paasta.scwui.model;


import com.paasta.scwui.common.util.DateUtil;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.Map;

@Getter
@Setter
@ToString
public class User extends sonia.scm.user.User{

    public User(){
    }
    /**
     * Constructs ...
     *
     * @param name
     */
    public User(String name) {
        this.name = name;
        this.displayName = name;
    }

    /**
     * Constructs ...
     *
     * @param name
     * @param displayName
     * @param mail
     */
    public User(String name, String displayName, String mail) {
        this.name = name;
        this.displayName = displayName;
        this.mail = mail;
    }

    /**
     * Constructs ...
     *
     * @param map
     */
    public User(Map map) {
        Map scUserMap = (Map) map.get("ScUser");
        Map rtnUser = (Map) map.get("rtnUser");
        this.name = (String) scUserMap.getOrDefault("userId", "");
        this.displayName = (String) scUserMap.getOrDefault("userName", "");
        this.mail = (String) scUserMap.getOrDefault("userMail", "");
        this.desc = (String) scUserMap.getOrDefault("userDesc", "");
        this.admin = (boolean) rtnUser.getOrDefault("admin", false);
        this.active = (boolean) rtnUser.getOrDefault("active", false);
        this.type = (String) rtnUser.getOrDefault("type", "");
        this.password = (String) rtnUser.getOrDefault("password", "");
    }

    /** Field description */
    private boolean active = true;

    /** Field description */
    private boolean admin = false;

    /** Field description */
    private Long creationDate;

    /** Field description */
    private String displayName;

    /** Field description */
    private Long lastModified;

    /** Field description */
    private String mail;

    /** Field description */
    private String name;

    /** Field description */
    private String password;

    /** Field description */
    private String type;

    /** Field description */
    private String sCreationDate;

    /** Field description */
    private Long sLastModified;

    /** Field description */
    private String desc;

    public String getsCreationDate() {
        return this.creationDate > 0 ? DateUtil.convertLongToTime(this.creationDate) : "";
    }

    public String getsLastModified() {
        return this.lastModified > 0 ? DateUtil.convertLongToTime(this.lastModified) : "";
    }
}