package com.paasta.scwui.common.util;

import lombok.Getter;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * Created by lena on 2017-06-23.
 */
@Component
@Setter
@Getter
//@Configuration
//@PropertySource("file:application.properties")//active profiles 설정후 변경
public class PropertiesUtil {

    /**
     * The Base url.
     */
    @Value("${api.base.url}") String base_url;

    //====== [Sc Api Server Authentication Resource Api]


    //====== [Sc Api Server Repository Resource Api]
    /**
     * The Api Repository.
     */
    @Value("${api.repo}") String api_repo;
    /**
     * The Api Repository id.
     */
    @Value("${api.repo.id}") String api_repo_id;

    /**
     * The Api Repository name.
     */
    @Value("${api.repo.type.name}") String api_repo_type_name;

    /**
     * The Api Repository name.
     */
    @Value("${api.repo.name}") String api_repo_name;

    /**
     * The Api Repository super admin.
     */
    @Value("${api.repo.dashboard.admin}") String api_repo_dashboard_admin;
    /**
     * The Api Repository user.
     */
    @Value("${api.repo.dashboard}") String api_repo_dashboard;
    /**
     * The Api Repository branches.
     */
    @Value("${api.repository.id.branches}") String api_repo_branches;
    /**
     * The Api Repository tags.
     */
    @Value("${api.repository.id.tags}") String api_repo_tags;
    /**
     * The Api Repository Browse.
     */
    @Value("${api.repository.id.browse}") String api_repo_browse;
    /**
     * The Api Repository changesets.
     */
    @Value("${api.repository.id.changesets}") String api_repo_changesets;

    /**
     * The Api ServiceInstances
     */
    @Value("${api.serviceInstances}") String api_serviceInstances;
    /**
     * The Api user
     */
    @Value("${api.users}") String api_users;
    /**
     * The Api login
     */
    @Value("${api.login}") String api_login;
    /**
     * The Api Permission
     */
    @Value("${api.permission}") String api_permission;
    /**
     * The Api Permission Admin
     */
    @Value("${api.permission.admin}") String api_permission_admin;
    /**
     * The Api Permission Search
     */
    @Value("${api.permission.search.repositoryId}") String api_permission_search_repositoryId;
    /**
     * The Api auth
     */
    @Value("${api.auth}") String api_auth;
    /**
     * The Api user
     */
    @Value("${api.users.user}") String api_users_user;

    /**
     * The Api Permission Search InstanceId
     */
    @Value("${api.permission.search.instanceId}") String api_permission_search_instanceId;

    /**
     * The Api Permission user
     */
    @Value("${api.permission.user}") String api_permission_user;
    /**
     * The Api content repository
     */
    @Value("${api.repository.id.content.path.revision}") String  apiRepositoryIdContentPathRevision;

    @Override
    public String toString() {
        return "PropertiesUtil{" +
                "base_url='" + base_url + '\'' +
                ", api_repo='" + api_repo + '\'' +
                ", api_repo_id='" + api_repo_id + '\'' +
                ", api_repo_type_name='" + api_repo_type_name + '\'' +
                ", api_repo_name='" + api_repo_name + '\'' +
                ", api_repo_dashboard_admin='" + api_repo_dashboard_admin + '\'' +
                ", api_repo_dashboard='" + api_repo_dashboard + '\'' +
                ", api_repo_branches='" + api_repo_branches + '\'' +
                ", api_repo_tags='" + api_repo_tags + '\'' +
                ", api_repo_browse='" + api_repo_browse + '\'' +
                ", api_repo_changesets='" + api_repo_changesets + '\'' +
                ", api_serviceInstances='" + api_serviceInstances + '\'' +
                ", api_users='" + api_users + '\'' +
                ", api_login='" + api_login + '\'' +
                ", api_permission='" + api_permission + '\'' +
                ", api_permission_admin='" + api_permission_admin + '\'' +
                ", api_permission_search_repositoryId='" + api_permission_search_repositoryId + '\'' +
                ", api_auth='" + api_auth + '\'' +
                ", api_users_user='" + api_users_user + '\'' +
                ", api_permission_search_instanceId='" + api_permission_search_instanceId + '\'' +
                ", api_permission_user='" + api_permission_user + '\'' +
                ", apiRepositoryIdContentPathRevision='" + apiRepositoryIdContentPathRevision + '\'' +
                '}';
    }
}
