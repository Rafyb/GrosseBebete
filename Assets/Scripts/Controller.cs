using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Controller : MonoBehaviour
{
    private Transform tf;              // this transform
    private Vector3 dest;        // The destination Point
    private float dist;

    public float speed = 100f;

    public Cinemachine.CinemachineVirtualCamera cam;

    public GameObject targetedPrefab;
    private GameObject targeted;



    private Interactible villager;

    public List<GameObject> Collectables = new List<GameObject>();
    public Animator anim;
    public Transform hand;

    void Start()
    {
        tf = GetComponent<Transform>();
        dest = tf.position;
    }

    void Update()
    {
        if (Game.Instance.locked) return;

        anim.SetFloat("speed", Vector3.Distance(tf.position, dest));

        if (Input.GetMouseButtonDown(1))
        {
            Plane playerPlane = new Plane(Vector3.up, tf.position);
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            float hitdist = 0.0f;

            if (playerPlane.Raycast(ray, out hitdist))
            {
                if(targeted != null)
                {
                    Destroy(targeted);
                }

                //Deplacement
                dest = ray.GetPoint(hitdist);
                dest.y = tf.position.y;

                targeted = Instantiate(targetedPrefab, dest, Quaternion.identity);

                dist = Vector3.Distance(tf.position, dest);

                tf.DOKill();
                tf.DOMove(dest, dist * (1/speed) ).OnComplete( ()=> {
                    if (targeted != null)
                    {
                        Destroy(targeted);
                    }
                });

                // Rotation
                Vector3 targetPoint = ray.GetPoint(hitdist);
                Quaternion targetRotation = Quaternion.LookRotation(targetPoint - transform.position);
                tf.rotation = targetRotation;
            }
        }

        if (Input.GetAxis("Mouse ScrollWheel") > 0f) // forward
        {
            if (cam.m_Lens.OrthographicSize < 20) cam.m_Lens.OrthographicSize++;
        }
        else if (Input.GetAxis("Mouse ScrollWheel") < 0f) // backwards
        {
            if(cam.m_Lens.OrthographicSize > 5 ) cam.m_Lens.OrthographicSize--;
        }

        if(Input.GetButtonDown("E"))
        {
            if (villager == null) GetCollectable();
            else PutVillager();
        }

        if (Input.GetButtonDown("R"))
        {
            if (villager != null) ThrowVillager();
        }

    }

    private void GetCollectable()
    {
        Recoltable item;

        tf.DOKill();
        dest = tf.position;

        for (int i = 0; i < Collectables.Count; i++)
        {
            GameObject gameobject = Collectables[i];

            if (gameobject.TryGetComponent<Interactible>(out villager))
            {
                villager.transform.parent = hand;
                villager.GetComponent<Rigidbody>().isKinematic = true;
                villager.transform.localPosition = Vector3.zero;
                Collectables.RemoveAt(i);
                anim.SetTrigger("Take");
                anim.SetBool("Taked", true);
                return;
            }

            else if (gameobject.TryGetComponent<Recoltable>(out item))
            {
                if (!item.recoltable) return;

                Instantiate(item.fx, item.transform.position, Quaternion.identity);

                if (item.type == TypeRessource.Tree) Game.Instance.tree++;
                if (item.type == TypeRessource.Box) Game.Instance.box++;
                
                Collectables.RemoveAt(i);
                Destroy(gameobject);
                Game.Instance.UpdateUI();
                return;
            }
        }

    }
    private void PutVillager()
    {
        villager.GetComponent<Rigidbody>().isKinematic = false;
        anim.SetTrigger("Put");
        anim.SetBool("Taked", false);
        villager.transform.parent = null;
        villager = null;

    }

    private void ThrowVillager()
    {
        Game.Instance.BadAct(villager.gameObject.transform);

        villager.GetComponent<Rigidbody>().isKinematic = false;
        anim.SetTrigger("Throw");
        anim.SetBool("Taked", false);
        villager.transform.parent = null;
        villager.GetComponent<Rigidbody>().AddForce(new Vector3(Random.Range(-1,1)*15f, 10f , Random.Range(-1, 1) * 15f), ForceMode.Impulse);
        villager = null;
    }


}
