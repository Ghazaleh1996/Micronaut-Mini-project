package com.example.repository;
import com.example.dao.Merchant;
import com.example.dao.Merchant;
import io.micronaut.data.annotation.Repository;
import io.micronaut.data.repository.CrudRepository;

@Repository
public interface MerchantRepository extends CrudRepository<Merchant, Long> {

}

