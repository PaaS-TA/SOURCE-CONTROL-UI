package com.paasta.scwui.config;

import javax.servlet.Filter;

/**
 * Wrapper around a {@link Filter}. This wrapper is used because if a
 * {@link Filter} is defined as a Spring bean, it will be automatically
 * registered in the security chain.
 *
 * @author Sebastien Gerard
 */
class FilterWrapper {

    /**
     * Returns a wrapper around the specified filter.
     */
    static FilterWrapper wrap(Filter filter){
        return new FilterWrapper(filter);
    }

    private final Filter filter;

    FilterWrapper(Filter filter) {
        this.filter = filter;
    }

    /**
     * Un-wraps the filter.
     */
    Filter unwrap() {
        return filter;
    }
}
