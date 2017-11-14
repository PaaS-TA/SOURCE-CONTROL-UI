package com.paasta.scwui.config;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.oauth2.provider.authentication.OAuth2AuthenticationManager;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;
import org.springframework.security.web.authentication.preauth.AbstractPreAuthenticatedProcessingFilter;
import org.springframework.security.web.util.matcher.RequestMatcher;
import org.springframework.web.context.request.RequestContextListener;

import static com.paasta.scwui.config.DashboardSecurityConfiguration.isManagingApp;

@Configuration
@Order(2)
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    /**
     * Role that users accessing the dashboard endpoint must have.
     */
    public static final String ROLE_OWNER = "ROLE_OWNER";

    /**
     * Role that users accessing a web-service endpoint must have.
     */
    public static final String ROLE_ADMIN= "ROLE_ADMIN";

    @Bean(name = "authenticationManager")
    public AuthenticationManager authenticationManagerBean() {
        try {
            return super.authenticationManager();
        }catch(Exception e){

            DashboardSecurityConfiguration.logger.debug("<<<<<<<<<<<<<authenticationManager<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
            e.printStackTrace();
            DashboardSecurityConfiguration.logger.debug("<<<<<<<<<<<<<authenticationManager<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
        }
        return new OAuth2AuthenticationManager();
    }

    @Bean
    @ConditionalOnMissingBean(RequestContextListener.class)
    public RequestContextListener requestContextListener() {
        return new RequestContextListener();
    }
    /**
     * 모든 페이징 권한주기
     **/
/*    @Override
    public void configure(WebSecurity web) throws Exception {
        //resources 들의 인증권한은 모두 풀어준다.
        web.ignoring().antMatchers("*//**");
        web.ignoring().antMatchers("/resources*//**");
    }*/
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
                .csrf().disable()
                .authorizeRequests()
                .antMatchers("/user/**").access("hasRole('"+ROLE_OWNER+"')")
                .antMatchers("/template/*").access("hasRole('"+ROLE_OWNER+"')")
                .antMatchers("/admin/**").access("hasRole('"+ROLE_ADMIN+"')")//.permitAll()
                .antMatchers("/c2NtYWRtaW46/").permitAll()
                .antMatchers("/resource/**").permitAll()
                .antMatchers("/error/*").permitAll()
                .and()
                .logout()
                .logoutSuccessUrl("/index")
                .invalidateHttpSession(true)
                .and()
                .exceptionHandling().accessDeniedPage("/error/403");
    }

    /**
     * {@link WebSecurityConfigurerAdapter} securing the dashboard.
     */
    @Configuration
    @Order(1)
    public static class DashboardWebSecurityConfigurationAdapter extends WebSecurityConfigurerAdapter {

        @Autowired
        @Qualifier("dashboardAuthenticationProvider")
        private AuthenticationProvider dashboardAuthenticationProvider;
        @Autowired
        @Qualifier("dashboardEntryPointMatcher")
        private RequestMatcher dashboardEntryPointMatcher;

        @Autowired
        @Qualifier("dashboardClientContextFilter")
        private FilterWrapper dashboardClientContextFilter;

        @Autowired
        @Qualifier("dashboardSocialClientFilter")
        private FilterWrapper dashboardSocialClientFilter;

        @Autowired
        @Qualifier("dashboardLogoutSuccessHandler")
        private LogoutSuccessHandler dashboardLogoutSuccessHandler;

        @Autowired
        @Qualifier("dashboardLogoutUrlMatcher")
        private RequestMatcher dashboardLogoutUrlMatcher;

        @Override
        protected void configure(HttpSecurity http) throws Exception {
            http
                    .requestMatcher(dashboardEntryPointMatcher)
                    .authorizeRequests()
                    .anyRequest().access(isManagingApp())
                    .and()

                    .addFilterBefore(dashboardClientContextFilter.unwrap(), AbstractPreAuthenticatedProcessingFilter.class)
                    .addFilterBefore(dashboardSocialClientFilter.unwrap(), AbstractPreAuthenticatedProcessingFilter.class)

                    .logout()
//                    .logoutSuccessHandler(dashboardLogoutSuccessHandler)
//                    .logoutRequestMatcher(dashboardLogoutUrlMatcher)
                    .and()
                    .exceptionHandling().accessDeniedPage("/error/500");
        }

        @Override
        protected void configure(AuthenticationManagerBuilder auth) {
            auth.authenticationProvider(dashboardAuthenticationProvider);
        }

    }
}
