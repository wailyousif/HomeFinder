package com.ironyard.repo;

import com.ironyard.data.AppUser;
import org.springframework.data.repository.PagingAndSortingRepository;

/**
 * Created by wailm.yousif on 3/22/17.
 */
public interface AppUserRepo extends PagingAndSortingRepository<AppUser, Long> {

    public AppUser findByEmail(String email);

    public AppUser findByEmailAndPassword(String email, String password);
}
