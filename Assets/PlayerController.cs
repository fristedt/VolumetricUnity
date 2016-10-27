using UnityEngine;
using System.Collections;

public class PlayerController : MonoBehaviour {
    private const float MaxVelocity = .1f;
    private const float SpeedH = 2.0f;
    private const float SpeedV = 2.0f;

    private float forward = 0.0f;
    private float strafe = 0.0f;
    private float yaw = 0.0f;
    private float pitch = 0.0f;

    // Use this for initialization
    void Start () {
	}
	
	// Update is called once per frame
	void Update () {
        strafe = Input.GetAxis("Horizontal");
        forward = Input.GetAxis("Vertical");
        Vector3 velocity = new Vector3(strafe, 0, forward).normalized * MaxVelocity;
        transform.Translate(velocity * Time.deltaTime);

        yaw += SpeedH * Input.GetAxis("Mouse X");
        pitch -= SpeedV * Input.GetAxis("Mouse Y");

        transform.eulerAngles = new Vector3(pitch, yaw, 0.0f);

    }
}
