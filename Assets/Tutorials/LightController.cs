using UnityEngine;
using System.Collections;

public class LightController : MonoBehaviour {
    private const float RotationSpeed = 100;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
        transform.Rotate(0, RotationSpeed * Time.deltaTime, 0);
	}
}
