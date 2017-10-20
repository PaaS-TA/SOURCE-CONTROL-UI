package com.paasta.scwui.model;

import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.stream.Collectors;

@Setter
@Getter
public class BrowserResult extends sonia.scm.repository.BrowserResult {
    public BrowserResult() {}

    private List<FileObject> newFiles;

    public void setNewFiles(List<sonia.scm.repository.FileObject> list)
    {
        @SuppressWarnings("unchecked") List<FileObject> newList = list.stream().map(FileObject::new).collect(Collectors.toList());
        this.newFiles = newList;

    }

    @Override
    public String toString() {
        return "BrowserResult{" +
                "newFiles=" + newFiles +
                '}';
    }
}
