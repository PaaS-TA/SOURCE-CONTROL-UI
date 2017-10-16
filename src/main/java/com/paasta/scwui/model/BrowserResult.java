package com.paasta.scwui.model;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Setter
@Getter
public class BrowserResult extends sonia.scm.repository.BrowserResult {
    public BrowserResult() {}

    private List<FileObject> newFiles;

    public void setNewFiles(List<sonia.scm.repository.FileObject> list)
    {
        List<FileObject> newList = new ArrayList();
        for(int i =0; i< list.size();i++){
            FileObject fileObject = new FileObject(list.get(i));
            newList.add(fileObject);
        }
        this.newFiles = newList;

    }

    @Override
    public String toString() {
        return "BrowserResult{" +
                "newFiles=" + newFiles +
                '}';
    }
}
