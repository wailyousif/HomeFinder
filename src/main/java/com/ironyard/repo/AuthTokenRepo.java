package com.ironyard.repo;

import com.ironyard.data.AuthToken;
import org.springframework.data.repository.PagingAndSortingRepository;

/**
 * Created by wailm.yousif on 3/27/17.
 */
public interface AuthTokenRepo extends PagingAndSortingRepository<AuthToken, Long> {
    public AuthToken findByTokenString(String tokenString);
}
