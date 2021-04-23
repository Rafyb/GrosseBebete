using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Menu : MonoBehaviour
{
    public GameObject credit;

    private void Start()
    {
        credit.SetActive(false);
    }
    public void Play()
    {
        SceneManager.LoadScene(0);
    }

    public void Credit()
    {
        credit.SetActive(true);
    }

    public void QuitCredit()
    {
        credit.SetActive(false);
    }

    public void Quit()
    {
        Application.Quit();
    }
}
