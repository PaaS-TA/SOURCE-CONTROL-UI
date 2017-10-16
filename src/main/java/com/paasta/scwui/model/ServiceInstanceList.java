package com.paasta.scwui.model;

import java.util.List;

/**
 * Created by user on 2017-07-10.
 */

public class ServiceInstanceList {
    int total;
    int start;
    int display;
    List<ServiceInstances> serviceInstances;

    int page;
    int size;
    int totalPages;
    long totalElements;
    boolean isLast;

    public ServiceInstanceList(){
    }

    public ServiceInstanceList(List<ServiceInstances> serviceInstances){
        this.serviceInstances = serviceInstances;
    }

    public ServiceInstanceList(int total, int start, int display, List<ServiceInstances>serviceInstances) {
        this.total = total;
        this.start = start;
        this.display = display;
        this.serviceInstances = serviceInstances;
    }

    public List<ServiceInstances> getServiceInstances(){
        return serviceInstances;
    }

    public void setServiceInstances(List<ServiceInstances> serviceInstances) {
        this.serviceInstances=serviceInstances;
    }

    //Generate Getter&Setter

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public int getStart() {
        return start;
    }

    public void setStart(int start) {
        this.start = start;
    }

    public int getDisplay() {
        return display;
    }

    public void setDisplay(int display) {
        this.display = display;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
    }

    public long getTotalElements() {
        return totalElements;
    }

    public void setTotalElements(long totalElements) {
        this.totalElements = totalElements;
    }

    public boolean isLast() {
        return isLast;
    }

    public void setLast(boolean last) {
        isLast = last;
    }

}
