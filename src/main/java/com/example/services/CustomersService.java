package com.example.services;

import com.example.dao.Customer;
import jakarta.inject.Singleton;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

import java.util.List;

@Singleton
@Slf4j
public class CustomersService {

    @PersistenceContext
    EntityManager em;

    @Transactional
    public List<Customer> list() {
        return em
            .createQuery("SELECT c FROM Customer c", Customer.class)
            .getResultList();
    }

    @Transactional
    public Customer find(int id) {
        return em
            .createQuery("SELECT c FROM Customer c WHERE c.id = :customerId", Customer.class)
            .setParameter("customerId", id)
            .getSingleResult();
    }

    @Transactional
    public Customer update(int customerId, String name, String surname) {
        var customer = em.find(Customer.class, customerId);
        customer.setName(name);
        customer.setSurname(surname);
        em.merge(customer);
        log.debug("updated customer {}", customerId);
        return customer;
    }

    @Transactional
    public Customer update(int id, int points,int delta,String name, String surname) {
        var customer=em.find(Customer.class, id);
        customer.setName(name);
        customer.setSurname(surname);
        int newPoints= customer.getPoints()+delta;
        customer.setPoints(newPoints);
        em.merge(customer);
        log.debug("updated customer points {}",id);
        return customer;
    }

    //Retrieve summary data: number of customers, total circulating points
    /*public Customer summary(int id) {
        var totalCustomers = em.createQuery("SELECT COUNT(c) FROM Customer c", Customer.class)
                .getSingleResult();

        var totalPoints = em.createQuery("SELECT COALESCE(SUM(c.points), 0) FROM Customer c", Customer.class)
                .getSingleResult();
        return totalCustomers , totalPoints;

    }*/
}
