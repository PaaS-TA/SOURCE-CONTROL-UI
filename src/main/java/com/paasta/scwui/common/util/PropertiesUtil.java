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
    @Value("${api.base.url}") String baseUrl;

    //====== [Sc Api Server Authentication Resource Api]


    //====== [Sc Api Server Repository Resource Api]
    /**
     * The Api Repository.
     */
    @Value("${api.repo}") String apiRepo;
    /**
     * The Api Repository id.
     */
    @Value("${api.repo.id}") String apiRepoId;

    /**
     * The Api Repository name.
     */
    @Value("${api.repo.type.name}") String apiRepoTypeName;

    /**
     * The Api Repository name.
     */
    @Value("${api.repo.name}") String apiRepoName;

    /**
     * The Api Repository super admin.
     */
    @Value("${api.repo.dashboard.admin}") String apiRepoDashboardAdmin;
    /**
     * The Api Repository user.
     */
    @Value("${api.repo.dashboard}") String apiRepoDashboard;
    /**
     * The Api Repository branches.
     */
    @Value("${api.repository.id.branches}") String apiRepoBranches;
    /**
     * The Api Repository tags.
     */
    @Value("${api.repository.id.tags}") String apiRepoTags;
    /**
     * The Api Repository Browse.
     */
    @Value("${api.repository.id.browse}") String apiRepoBrowse;
    /**
     * The Api Repository changesets.
     */
    @Value("${api.repository.id.changesets}") String apiRepoChangesets;

    /**
     * The Api ServiceInstances
     */
    @Value("${api.serviceInstances}") String apiServiceInstances;
    /**
     * The Api user
     */
    @Value("${api.users}") String apiUsers;
    /**
     * The Api login
     */
    @Value("${api.login}") String apiLogin;
    /**
     * The Api Permission
     */
    @Value("${api.permission}") String apiPermission;
    /**
     * The Api Permission Admin
     */
    @Value("${api.permission.admin}") String apiPermissionAdmin;
    /**
     * The Api Permission Search
     */
    @Value("${api.permission.search.repositoryId}") String apiPermissionSearchRepositoryId;
    /**
     * The Api auth
     */
    @Value("${api.auth}") String apiAuth;
    /**
     * The Api user
     */
    @Value("${api.users.user}") String apiUsersUser;

    /**
     * The Api Permission Search InstanceId
     */
    @Value("${api.permission.search.instanceId}") String apiPermissionSearchInstanceId;

    /**
     * The Api Permission user
     */
    @Value("${api.permission.user}") String apiPermissionUser;
    /**
     * The Api content repository
     */
    @Value("${api.repository.id.content.path.revision}") String  apiRepositoryIdContentPathRevision;

    @Override
    public String toString() {
        return "PropertiesUtil{" +
                "baseUrl='" + baseUrl + '\'' +
                ", apiRepo='" + apiRepo + '\'' +
                ", apiRepoId='" + apiRepoId + '\'' +
                ", apiRepoTypeName='" + apiRepoTypeName + '\'' +
                ", apiRepoName='" + apiRepoName + '\'' +
                ", apiRepoDashboardAdmin='" + apiRepoDashboardAdmin + '\'' +
                ", apiRepoDashboard='" + apiRepoDashboard + '\'' +
                ", apiRepoBranches='" + apiRepoBranches + '\'' +
                ", apiRepoTags='" + apiRepoTags + '\'' +
                ", apiRepoBrowse='" + apiRepoBrowse + '\'' +
                ", apiRepoChangesets='" + apiRepoChangesets + '\'' +
                ", apiServiceInstances='" + apiServiceInstances + '\'' +
                ", apiUsers='" + apiUsers + '\'' +
                ", apiLogin='" + apiLogin + '\'' +
                ", apiPermission='" + apiPermission + '\'' +
                ", apiPermissionAdmin='" + apiPermissionAdmin + '\'' +
                ", apiPermissionSearchRepositoryId='" + apiPermissionSearchRepositoryId + '\'' +
                ", apiAuth='" + apiAuth + '\'' +
                ", apiUsersUser='" + apiUsersUser + '\'' +
                ", apiPermissionSearchInstanceId='" + apiPermissionSearchInstanceId + '\'' +
                ", apiPermissionUser='" + apiPermissionUser + '\'' +
                ", apiRepositoryIdContentPathRevision='" + apiRepositoryIdContentPathRevision + '\'' +
                '}';
    }
}
