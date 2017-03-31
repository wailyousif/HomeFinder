package com.ironyard.repo;

import com.ironyard.data.AppUser;
import com.ironyard.data.SearchSave;
import org.springframework.data.repository.PagingAndSortingRepository;

/**
 * Created by wailm.yousif on 3/28/17.
 */
public interface SearchSaveRepo extends PagingAndSortingRepository<SearchSave, Long> {
    public SearchSave findByAppUser(AppUser appUser);
    public SearchSave findByIdAndAppUser(Long id, AppUser appUser);
}
