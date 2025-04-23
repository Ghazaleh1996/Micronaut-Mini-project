package com.example.services;

import com.example.dao.Customer;
import com.example.dao.Transaction;
import jakarta.inject.Singleton;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    @Transactional
    public Map<Integer,Integer> getSummaryData(){
        Long totalCustomers =em.createQuery("SELECT count(c) FROM Customer c", Long.class)
                .getSingleResult();
        Long totalPoints = em.createQuery("SELECT SUM(c.points) FROM Customer c", Long.class)
                .getSingleResult();

        Map<String, Integer> summary = new HashMap<>();
        summary.put("customerCount", totalCustomers.intValue());
        summary.put("totalPoints", totalPoints.intValue());

        return summary;
    }
    @Transactional
    public Customer summary(int customerId, int points) {
        var customer=em.find(Customer.class, customerId);
        int newPoints= customer.getPoints()+points;
        customer.setPoints(newPoints);
        em.merge(customer);
        var tx = new Transaction();
        tx.setCustomer(customer);
        tx.setPoints(points);
        em.persist(tx);
        log.debug("updated customer points {}",customerId);
        return customer;
    }
}
