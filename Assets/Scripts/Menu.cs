using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Menu : MonoBehaviour
{
    public GameObject commandes;

    private void Start()
    {
        commandes?.SetActive(false);
    }
    public void Play()
    {
        SceneManager.LoadScene("Game");
    }

    public void Credit()
    {
        commandes.SetActive(true);
    }

    public void QuitCredit()
    {
        commandes.SetActive(false);
    }

    public void Quit()
    {
        Application.Quit();
    }
}
