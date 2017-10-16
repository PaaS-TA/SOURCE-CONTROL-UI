package com.paasta.scwui.common.util;

public class ListRequest {

    private String organizationName;

    private String repoName;

    //getter&setter
    public String getOrganizationName() {
        return organizationName;
    }

    public void setOrganizationName(String organizationName) {
        this.organizationName = organizationName;
    }

    public String getRepoName() {
        return repoName;
    }

    public void setRepoName(String repoName) {
        this.repoName = repoName;
    }


    //toQueryString
    public String toQueryString(){
        StringBuilder sb = new StringBuilder();

        if(organizationName != null){
            sb.append("organizationName="+organizationName);
        }
        return sb.toString();
    }
}
