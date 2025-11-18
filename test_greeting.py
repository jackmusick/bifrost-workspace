"""
Test Greeting Workflow

A simple workflow for testing the Run panel in the code editor.
Demonstrates different parameter types.
"""

import logging
from bifrost import ExecutionContext, param, workflow


@workflow(
    name="test_greeting",
    description="Test workflow for code editor",
    category="testing",
    tags=["test", "editor"],
    execution_mode="async"
)
@param("name", type="string", label="Your Name", required=True, help_text="Enter your name")
@param("greeting_type", type="string", label="Greeting", required=False, default_value="Hello", help_text="Type of greeting (Hello, Hi, Hey)")
@param("repeat_count", type="int", label="Repeat Count", required=False, default_value=1, help_text="How many times to repeat")
@param("uppercase", type="bool", label="Uppercase", required=False, default_value=False, help_text="Make the greeting uppercase")
async def test_greeting(
    context: ExecutionContext,
    name: str,
    greeting_type: str = "Hello",
    repeat_count: int = 1,
    uppercase: bool = False
) -> dict:
    """
    Simple test workflow that creates personalized greetings.

    Args:
        context: Organization context
        name: Your name
        greeting_type: Type of greeting
        repeat_count: How many times to repeat the greeting
        uppercase: Whether to convert to uppercase

    Returns:
        Dictionary with greeting messages and metadata
    """

    print("Starting test_greeting workflow...")
    logging.debug(
        f"Starting test_greeting workflow for {name} with greeting_type={greeting_type}, repeat_count={repeat_count}, uppercase={uppercase}")
    logging.warning("This is a test warning message")
    logging.error("This is a test error message")

    some_var = {"key": "value"}
    some_other_var = [1, 2, 3]
    some_other_other_var = "Just a string"

    greetings = []

    for i in range(repeat_count):
        greeting = f"{greeting_type}, {name}!"

        if uppercase:
            greeting = greeting.upper()

        greetings.append(greeting)
        logging.info(f"Greeting #{i+1}: {greeting}")

    return {
        "greetings": greetings,
        "count": len(greetings),
        "name": name,
        "org_name": context.org_name,
        "user": context.name
    }
