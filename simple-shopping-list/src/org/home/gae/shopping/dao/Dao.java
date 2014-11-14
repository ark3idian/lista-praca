package org.home.gae.shopping.dao;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.Query;

import org.home.gae.shopping.model.Article;

public enum Dao {
  INSTANCE;

  public List<Article> listArticles() {
    EntityManager em = EMFService.get().createEntityManager();
    // read the existing entries
    Query q = em.createQuery("select m from Article m");
    List<Article> articles = q.getResultList();
    return articles;
  }

  public void add(String user, String name, int amount) {
    synchronized (this) {
      EntityManager em = EMFService.get().createEntityManager();
      Article article = new Article(user, name, amount);
      em.persist(article);
      em.close();
    }
  }

  public List<Article> getArticles(String userId) {
    EntityManager em = EMFService.get().createEntityManager();
    Query q = em
        .createQuery("select t from Article t where t.user = :userId");
    q.setParameter("userId", userId);
    List<Article> articles = q.getResultList();
    return articles;
  }

  public void remove(long id) {
    EntityManager em = EMFService.get().createEntityManager();
    try {
      Article article = em.find(Article.class, id);
      em.remove(article);
    } finally {
      em.close();
    }
  }
}
